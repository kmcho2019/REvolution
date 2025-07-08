module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);

    reg [1:0] cnt;
    reg active;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b00;
            active <= 1'b1;
            shift_ena <= 1'b1;
        end else if (active) begin
            if (cnt == 2'd3) begin
                active <= 1'b0;
                shift_ena <= 1'b0;
            end else begin
                cnt <= cnt + 1'b1;
                shift_ena <= 1'b1;
            end
        end else begin
            shift_ena <= 1'b0;
        end
    end

endmodule