module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State definitions - using parameters for better synthesis
parameter IDLE = 1'b0;
parameter GOT_FIRST = 1'b1;

reg state, next_state;
reg [7:0] first_byte;

// Combinational next state logic
always @(*) begin
    case (state)
        IDLE: next_state = valid_in ? GOT_FIRST : IDLE;
        GOT_FIRST: next_state = valid_in ? IDLE : GOT_FIRST;
        default: next_state = IDLE;
    endcase
end

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        first_byte <= 8'b0;
        data_out <= 16'b0;
        valid_out <= 1'b0;
    end else begin
        state <= next_state;
        
        // Store first byte when valid in IDLE state
        if (state == IDLE && valid_in)
            first_byte <= data_in;
            
        // Generate output when valid in GOT_FIRST state
        valid_out <= 1'b0;
        if (state == GOT_FIRST && valid_in) begin
            data_out <= {first_byte, data_in};
            valid_out <= 1'b1;
        end
    end
end

endmodule