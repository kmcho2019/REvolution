module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        start_shifting <= 0;
    end else begin
        case (state)
            0: begin
                if (data) state <= 1;
                else state <= 0;
            end
            1: begin
                if (data) state <= 2;
                else state <= 0;
            end
            2: begin
                if (data) state <= 2;
                else state <= 3;
            end
            3: begin
                if (data) state <= 4;
                else state <= 0;
            end
            4: begin
                state <= 4;
            end
        endcase
        if (state == 4) start_shifting <= 1;
        else start_shifting <= 0;
    end
end

endmodule