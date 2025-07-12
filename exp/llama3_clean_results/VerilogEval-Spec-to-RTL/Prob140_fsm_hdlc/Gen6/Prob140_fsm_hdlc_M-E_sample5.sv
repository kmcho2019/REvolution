module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
);

reg [7:0] shift_register;
reg [1:0] state;

always @(posedge clk) begin
    if (reset) begin
        shift_register <= 8'b0;
        state <= 2'b00;
        disc <= 0;
        flag <= 0;
        err <= 0;
    end else begin
        shift_register <= {shift_register[6:0], in};
        
        case (state)
            2'b00: begin
                if (shift_register == 8'b01111110) begin
                    state <= 2'b10;
                    flag <= 1;
                end else if (shift_register == 8'b0111110) begin
                    state <= 2'b01;
                    disc <= 1;
                end else if (shift_register[7:1] == 7'b1111111) begin
                    state <= 2'b11;
                    err <= 1;
                end
            end
            2'b01: begin
                state <= 2'b00;
                disc <= 0;
            end
            2'b10: begin
                state <= 2'b00;
                flag <= 0;
            end
            2'b11: begin
                if (~in) begin
                    state <= 2'b00;
                end
                err <= 1;
            end
        endcase
    end
end

endmodule