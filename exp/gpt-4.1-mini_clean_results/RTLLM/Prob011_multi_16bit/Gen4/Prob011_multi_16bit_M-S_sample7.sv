module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]    count;       // shift count from 0 to 16
    reg          done_r;
    reg [15:0]   areg;
    reg [31:0]   breg;        // multiplier shifted left progressively
    reg [31:0]   acc;         // accumulator for result

    // Control count and done
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
            done_r <= 1'b0;
        end else if (!start) begin
            count <= 5'd0;
            done_r <= 1'b0;
        end else if (count < 5'd16) begin
            count <= count + 5'd1;
            if (count == 5'd15)
                done_r <= 1'b1;
        end
    end

    // Shift and accumulate
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'd0;
            breg <= 32'd0;
            acc  <= 32'd0;
        end else if (!start) begin
            areg <= 16'd0;
            breg <= 32'd0;
            acc  <= 32'd0;
        end else if (count == 5'd0) begin
            // Load inputs on start
            areg <= ain;
            breg <= {16'd0, bin};
            acc  <= 32'd0;
        end else if (count <= 5'd16) begin
            if (areg[0])
                acc <= acc + breg;
            else
                acc <= acc;
            areg <= areg >> 1;
            breg <= breg << 1;
        end
    end

    assign yout = acc;
    assign done = done_r;

endmodule