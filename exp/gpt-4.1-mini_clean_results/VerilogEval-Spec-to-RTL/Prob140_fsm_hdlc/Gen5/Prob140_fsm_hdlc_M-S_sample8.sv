module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] state; // 0-6 count ones, 7 = error

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'd0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;

            case(state)
                3'd0: begin
                    if (in)
                        state <= 3'd1;
                    else
                        state <= 3'd0;
                end
                3'd1: begin
                    if (in)
                        state <= 3'd2;
                    else
                        state <= 3'd0;
                end
                3'd2: begin
                    if (in)
                        state <= 3'd3;
                    else
                        state <= 3'd0;
                end
                3'd3: begin
                    if (in)
                        state <= 3'd4;
                    else
                        state <= 3'd0;
                end
                3'd4: begin
                    if (in)
                        state <= 3'd5;
                    else
                        state <= 3'd0;
                end
                3'd5: begin
                    if (in)
                        state <= 3'd6;
                    else begin
                        state <= 3'd0;
                        disc <= 1'b1; // zero after five ones -> discard next cycle
                    end
                end
                3'd6: begin
                    if (in) begin
                        state <= 3'd7; // error state on 7+ ones
                        err   <= 1'b1;
                    end else begin
                        state <= 3'd0;
                        flag  <= 1'b1; // zero after six ones -> flag next cycle
                    end
                end
                3'd7: begin
                    err <= 1'b1; // error continuously asserted
                    if (in)
                        state <= 3'd7;
                    else
                        state <= 3'd0;
                end
                default: state <= 3'd0;
            endcase
        end
    end

endmodule