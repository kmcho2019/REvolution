module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [1:0] state; // Finite State Machine states: idle (0), first_data (1), second_data (2)
reg [15:0] shift_reg; // 16-bit shift register to store the concatenated data

// Sequential Logic for FSM and Shift Register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state       <= 2'd0;
        shift_reg   <= 16'd0;
        valid_out   <= 1'b0;
    end
    else begin
        case (state)
            2'd0: begin // Idle state
                if (valid_in) begin
                    shift_reg[15:8] <= data_in;
                    state           <= 2'd1;
                end
            end
            2'd1: begin // First data state
                if (valid_in) begin
                    shift_reg[7:0]  <= data_in;
                    state           <= 2'd2;
                    valid_out       <= 1'b1;
                end
                else begin
                    valid_out       <= 1'b0;
                end
            end
            2'd2: begin // Second data state
                if (!valid_in) begin
                    state           <= 2'd0;
                    valid_out      <= 1'b0;
                end
            end
        endcase
    end
end

// Combinational Logic for Output
assign data_out = shift_reg;

endmodule