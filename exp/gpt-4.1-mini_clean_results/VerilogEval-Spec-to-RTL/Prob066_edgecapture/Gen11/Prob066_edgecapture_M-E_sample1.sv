module TopModule (
    input              clk,
    input              reset,
    input      [31:0]  in,
    output     [31:0]  out
);

    reg [31:0] state;   // Tracks bits currently high and not yet captured ("armed")
    reg [31:0] capture; // Latched falling edge captures

    always @(posedge clk) begin
        if (reset) begin
            state   <= 32'b0;
            capture <= 32'b0;
        end else begin
            // Update state: bits set if input is high and not captured yet
            state <= (in & ~capture);

            // Detect falling edges: bits were armed (state=1) but now input=0
            // Capture falling edges by ORing these with capture
            capture <= capture | (state & ~in);
        end
    end

    assign out = capture;

endmodule