module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output wire valid_out,
    output wire [15:0] data_out
);

// State definitions
localparam IDLE = 1'b0;
localparam FIRST_RECEIVED = 1'b1;

reg state, next_state;
reg [7:0] stored_data;
reg [15:0] data_out_reg;
reg valid_out_reg;

// State transition logic
always @(*) begin
    case (state)
        IDLE: next_state = valid_in ? FIRST_RECEIVED : IDLE;
        FIRST_RECEIVED: next_state = valid_in ? IDLE : FIRST_RECEIVED;
        default: next_state = IDLE;
    endcase
end

// Sequential logic (state and storage)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        stored_data <= 8'b0;
        data_out_reg <= 16'b0;
        valid_out_reg <= 1'b0;
    end else begin
        state <= next_state;
        
        // Store first data when transitioning to FIRST_RECEIVED
        if (state == IDLE && next_state == FIRST_RECEIVED)
            stored_data <= data_in;
            
        // Generate output when transitioning back to IDLE
        if (state == FIRST_RECEIVED && next_state == IDLE) begin
            data_out_reg <= {stored_data, data_in};
            valid_out_reg <= 1'b1;
        end else begin
            valid_out_reg <= 1'b0;
        end
    end
end

// Continuous assignments for outputs
assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule