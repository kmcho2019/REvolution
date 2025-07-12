module TopModule (
    input          clk,
    input          reset,
    input  [2:0]   vec,
    output [2:0]   outv,
    output         o2,
    output         o1,
    output         o0
);
    reg [2:0] reg_vec;

    // Synchronous capture of the input vector
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_vec <= 3'b000;
        end else begin
            reg_vec <= vec;
        end
    end

    // Output assignments from registered vector
    assign outv = reg_vec;
    assign o0 = reg_vec[0];
    assign o1 = reg_vec[1];
    assign o2 = reg_vec[2];

endmodule