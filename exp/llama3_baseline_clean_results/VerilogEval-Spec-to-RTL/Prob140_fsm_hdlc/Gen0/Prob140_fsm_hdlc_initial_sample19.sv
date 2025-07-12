module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [1:0] state;
reg [2:0] count;
reg err_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        count <= 0;
        err_reg <= 0;
        disc <= 0;
        flag <= 0;
        err <= 0;
    end else begin
        case (state)
            0: begin // idle state
                if (in) begin
                    state <= 1;
                    count <= 1;
                end else begin
                    state <= 0;
                    count <= 0;
                end
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
            1: begin // one state
                if (in) begin
                    state <= 1;
                    count <= count + 1;
                    if (count == 5) begin
                        state <= 2;
                    end
                end else begin
                    state <= 0;
                    count <= 0;
                end
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
            2: begin // five_ones state
                if (in) begin
                    state <= 3;
                    count <= count + 1;
                end else begin
                    state <= 0;
                    count <= 0;
                    disc <= 1;
                end
                flag <= 0;
                err <= 0;
            end
            3: begin // flag state
                if (in) begin
                    err_reg <= 1;
                    state <= 0;
                    count <= 0;
                end else begin
                    state <= 0;
                    count <= 0;
                    flag <= 1;
                end
                disc <= 0;
                err <= err_reg;
            end
        endcase
        if (err_reg) begin
            err_reg <= 0;
        end
    end
end

endmodule