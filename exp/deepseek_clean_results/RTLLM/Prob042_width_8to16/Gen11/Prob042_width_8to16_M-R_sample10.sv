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
localparam GOT_FIRST_BYTE = 1'b1;

reg state, next_state;
reg [7:0] stored_byte;
reg [15:0] output_reg;

// State transitions
always @(posedge clk) begin
    if (!rst_n) begin
        state <= IDLE;
        stored_byte <= 8'b0;
        output_reg <= 16'b0;
    end else begin
        state <= next_state;
        
        if (valid_in) begin
            case (state)
                IDLE: stored_byte <= data_in;
                GOT_FIRST_BYTE: output_reg <= {stored_byte, data_in};
            endcase
        end
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    if (valid_in) begin
        case (state)
            IDLE: next_state = GOT_FIRST_BYTE;
            GOT_FIRST_BYTE: next_state = IDLE;
        endcase
    end
end

// Output assignments
assign valid_out = (state == GOT_FIRST_BYTE) && valid_in;
assign data_out = output_reg;

endmodule