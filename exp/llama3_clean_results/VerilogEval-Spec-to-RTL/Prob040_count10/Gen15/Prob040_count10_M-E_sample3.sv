module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;
reg [1:0] state; // COUNTING (0) and RESET (1)

// Define the states
parameter COUNTING = 2'd0;
parameter RESET = 2'd1;

always @(posedge clk) begin
    case (state)
        COUNTING: begin
            if (reset) begin
                state <= COUNTING;
                count <= 4'd0;
            end else if (count == 4'd9) begin
                state <= RESET;
                count <= 4'd0;
            end else begin
                state <= COUNTING;
                count <= count + 4'd1;
            end
        end
        RESET: begin
            state <= COUNTING;
            count <= 4'd0;
        end
        default: begin
            state <= COUNTING;
            count <= 4'd0;
        end
    endcase
end

assign q = count;

endmodule