module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] state;

    always @(posedge clk) begin
        if (load) begin
            state <= data;  // Parallel load
        end else if (|state) begin  // If not zero
            state <= {1'b0, state[9:1]};  // Right shift (count down)
        end
    end

    assign tc = (state == 10'b0000000001);  // Terminal count when LSB is set

endmodule