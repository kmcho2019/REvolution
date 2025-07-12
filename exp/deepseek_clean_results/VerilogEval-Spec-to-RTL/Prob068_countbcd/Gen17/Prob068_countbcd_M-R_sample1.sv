module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output reg [15:0] q
);

    // Combinational enable logic
    assign ena[0] = (q[3:0] == 4'd9);  // Ones digit enable
    assign ena[1] = (q[3:0] == 4'd9) && (q[7:4] == 4'd9);  // Tens digit enable
    assign ena[2] = (q[3:0] == 4'd9) && (q[7:4] == 4'd9) && (q[11:8] == 4'd9);  // Hundreds digit enable

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
        end else begin
            // Ones digit (always increments)
            if (q[3:0] == 4'd9) begin
                q[3:0] <= 4'd0;
            end else begin
                q[3:0] <= q[3:0] + 4'd1;
            end

            // Tens digit (increments when ones rolls over)
            if (ena[0]) begin
                if (q[7:4] == 4'd9) begin
                    q[7:4] <= 4'd0;
                end else begin
                    q[7:4] <= q[7:4] + 4'd1;
                end
            end

            // Hundreds digit (increments when tens rolls over)
            if (ena[1]) begin
                if (q[11:8] == 4'd9) begin
                    q[11:8] <= 4'd0;
                end else begin
                    q[11:8] <= q[11:8] + 4'd1;
                end
            end

            // Thousands digit (increments when hundreds rolls over)
            if (ena[2]) begin
                if (q[15:12] == 4'd9) begin
                    q[15:12] <= 4'd0;
                end else begin
                    q[15:12] <= q[15:12] + 4'd1;
                end
            end
        end
    end

endmodule