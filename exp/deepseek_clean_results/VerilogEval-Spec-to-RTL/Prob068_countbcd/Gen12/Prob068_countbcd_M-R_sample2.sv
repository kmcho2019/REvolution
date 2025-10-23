module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    wire [15:0] next_counter;
    
    // Enable generation (parallel)
    assign ena[0] = (counter[3:0] == 4'd9);
    assign ena[1] = (counter[7:4] == 4'd9) & ena[0];
    assign ena[2] = (counter[11:8] == 4'd9) & ena[1];
    
    // Next state logic (combinational)
    assign next_counter[3:0]   = reset ? 4'd0 : (counter[3:0] == 4'd9) ? 4'd0 : counter[3:0] + 4'd1;
    assign next_counter[7:4]   = reset ? 4'd0 : ena[0] ? ((counter[7:4] == 4'd9) ? 4'd0 : counter[7:4] + 4'd1) : counter[7:4];
    assign next_counter[11:8]  = reset ? 4'd0 : ena[1] ? ((counter[11:8] == 4'd9) ? 4'd0 : counter[11:8] + 4'd1) : counter[11:8];
    assign next_counter[15:12] = reset ? 4'd0 : ena[2] ? ((counter[15:12] == 4'd9) ? 4'd0 : counter[15:12] + 4'd1) : counter[15:12];
    
    assign q = counter;
    
    // State register (sequential)
    always @(posedge clk) begin
        counter <= next_counter;
    end

endmodule