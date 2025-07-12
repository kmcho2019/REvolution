module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state;
reg [1:0] count;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        count <= 0;
        start_shifting <= 0;
    end else begin
        case (state)
            0: begin
                if (data == 1) begin
                    state <= 1;
                    count <= 1;
                end
            end
            1: begin
                if (data == 1) begin
                    state <= 2;
                    count <= 2;
                end else if (data == 0) begin
                    state <= 0;
                    count <= 0;
                end
            end
            2: begin
                if (data == 0) begin
                    state <= 3;
                    count <= 3;
                end else begin
                    state <= 0;
                    count <= 0;
                end
            end
            3: begin
                if (data == 1) begin
                    start_shifting <= 1;
                end
            end
        endcase
    end
end

endmodule