module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [1:0] state; // 4 states: S0 (2'b00), S1 (2'b01), S2 (2'b10), S3 (2'b11)
reg [2:0] count; // Count consecutive 1s
reg disc_reg, flag_reg, err_reg; // Registered outputs

initial begin
    state = 2'b00;
    count = 3'b000;
    disc_reg = 1'b0;
    flag_reg = 1'b0;
    err_reg = 1'b0;
end

always @(posedge clk) begin
    if (reset) begin
        state = 2'b00;
        count = 3'b000;
        disc_reg = 1'b0;
        flag_reg = 1'b0;
        err_reg = 1'b0;
    end else begin
        case (state)
            2'b00: begin // S0
                if (in) begin
                    state = 2'b01; // Move to S1
                    count = 3'b001;
                end else begin
                    state = 2'b00; // Stay in S0
                    count = 3'b000;
                end
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end
            2'b01: begin // S1
                if (in) begin
                    state = 2'b10; // Move to S2
                    count = count + 1;
                end else begin
                    state = 2'b00; // Move to S0
                    count = 3'b000;
                end
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end
            2'b10: begin // S2
                if (in) begin
                    count = count + 1;
                    if (count == 6) begin
                        state = 2'b11; // Move to S3
                    end
                end else begin
                    state = 2'b00; // Move to S0
                    count = 3'b000;
                end
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end
            2'b11: begin // S3
                if (in) begin
                    state = 2'b11; // Stay in S3
                    err_reg = 1'b1; // Signal error
                end else begin
                    state = 2'b00; // Move to S0
                    count = 3'b000;
                    disc_reg = 1'b1; // Signal discard
                    if (count == 6) begin
                        flag_reg = 1'b1; // Signal flag
                    end
                end
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule