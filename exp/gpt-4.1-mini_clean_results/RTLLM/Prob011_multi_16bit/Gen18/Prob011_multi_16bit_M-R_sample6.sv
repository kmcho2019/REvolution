module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0]  yout,
    output reg         done
);

    // Internal registers
    reg [15:0] areg;
    reg [31:0] breg;
    reg [4:0]  count;
    reg        active;  // Indicates multiplication in progress

    // Next value signals
    reg [15:0] areg_next;
    reg [31:0] breg_next;
    reg [31:0] yout_next;
    reg [4:0]  count_next;
    reg        active_next;

    // Internal accumulator register
    reg [31:0] acc;

    // Sequential block to update registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 32'd0;
            acc    <= 32'd0;
            count  <= 5'd0;
            active <= 1'b0;
            yout   <= 32'd0;
            done   <= 1'b0;
        end else begin
            areg   <= areg_next;
            breg   <= breg_next;
            acc    <= yout_next;
            count  <= count_next;
            active <= active_next;
            yout   <= acc;
            done   <= (count == 5'd16);
        end
    end

    // Combinational logic to determine next states and data
    always @(*) begin
        // Default assignments
        areg_next = areg;
        breg_next = breg;
        yout_next = acc;
        count_next = count;
        active_next = active;

        if (!active) begin
            // Not active means waiting for start
            if (start) begin
                // Start multiplication: load inputs and reset accumulator and count
                areg_next = ain;
                breg_next = {16'd0, bin};
                yout_next = 32'd0;
                count_next = 5'd0;
                active_next = 1'b1;
            end
        end else begin
            // Multiplication in progress
            if (count < 5'd16) begin
                // Perform one multiply-accumulate step
                if (areg[0])
                    yout_next = acc + breg;
                else
                    yout_next = acc;

                // Shift areg right, breg left
                areg_next = areg >> 1;
                breg_next = breg << 1;

                // Increment count
                count_next = count + 5'd1;

                active_next = 1'b1;
            end else begin
                // Multiplication done after 16 cycles
                active_next = 1'b0;
            end
        end
    end

endmodule