module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State definitions - using binary encoding for better synthesis
localparam IDLE     = 1'b0;
localparam GOT_FIRST = 1'b1;

reg state, next_state;
reg [7:0] first_byte_reg;
reg [15:0] data_out_reg;
reg valid_out_reg;

// Combinational next state and output logic
always @(*) begin
    // Default assignments
    next_state = state;
    valid_out_reg = 1'b0;
    data_out_reg = data_out;

    case (state)
        IDLE: begin
            if (valid_in) begin
                next_state = GOT_FIRST;
            end
        end
        
        GOT_FIRST: begin
            if (valid_in) begin
                next_state = IDLE;
                data_out_reg = {first_byte_reg, data_in};
                valid_out_reg = 1'b1;
            end
        end
    endcase
end

// Sequential logic for state and data registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        first_byte_reg <= 8'b0;
        data_out <= 16'b0;
        valid_out <= 1'b0;
    end else begin
        state <= next_state;
        
        // Store first byte when transitioning to GOT_FIRST state
        if (state == IDLE && next_state == GOT_FIRST) begin
            first_byte_reg <= data_in;
        end
        
        // Register outputs for better timing
        data_out <= data_out_reg;
        valid_out <= valid_out_reg;
    end
end

endmodule