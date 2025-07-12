module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] count;
reg [1:0] state;

localparam A = 2'b00;
localparam B1 = 2'b01;
localparam B2 = 2'b10;
localparam B3 = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= A;
        count <= 0;
        z <= 0;
    end
    else begin
        case (state)
            A: begin
                if (s) begin
                    state <= B1;
                end
            end
            B1: begin
                if (w) begin
                    count <= count + 1;
                end
                state <= B2;
            end
            B2: begin
                if (w) begin
                    count <= count + 1;
                end
                state <= B3;
            end
            B3: begin
                if (w) begin
                    count <= count + 1;
                end
                if (count == 2) begin
                    z <= 1;
                end
                else begin
                    z <= 0;
                end
                count <= 0;
                state <= B1;
            end
        endcase
    end
end

endmodule