module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [3:0] count;
    reg       in_d;

    // Combinational next count logic with saturation at 7
    wire [3:0] count_next = (in_d) ? 
                           ((count < 4'd7) ? (count + 4'd1) : 4'd7) : 
                           4'd0;

    always @(posedge clk) begin
        if (reset) begin
            count <= 4'd0;
            in_d  <= 1'b0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            // Pipeline input for timing alignment
            in_d <= in;
            // Update count from previous input
            count <= count_next;

            // Outputs asserted one cycle after detection (Moore outputs)
            // Detection based on registered count and previous input (in_d)
            disc <= (count == 4'd5) && (~in_d);   // zero after five ones
            flag <= (count == 4'd6) && (~in_d);   // six ones then zero (flag)
            err  <= (in_d) && (count >= 4'd6);    // seven or more ones
        end
    end

endmodule