module multi_16bit (
    input         clk,
    input         rst_n,
    input         start,
    input  [15:0] ain,
    input  [15:0] bin,
    output reg [31:0] yout,
    output reg        done
);

    reg [4:0] i;             // iteration count 0..16
    reg [15:0] areg;         // multiplicand shift register (shift left each cycle)
    reg [15:0] breg;         // multiplier shift register (shift right each cycle)
    reg [31:0] yout_r;       // accumulator for product

    // iteration counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (start) begin
            if (i < 5'd16)
                i <= i + 5'd1;
            else
                i <= i;
        end else begin
            i <= 5'd0;
        end
    end

    // done signal logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done <= 1'b0;
        else if (i == 5'd16)
            done <= 1'b1;
        else if (!start)
            done <= 1'b0;
    end

    // main operation: load and iterate shift-add multiply
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                // load inputs at start
                areg   <= ain;
                breg   <= bin;
                yout_r <= 32'd0;
            end else if (i < 5'd16) begin
                // if LSB of breg is 1, add areg shifted appropriately
                if (breg[0])
                    yout_r <= yout_r + {16'd0, areg};
                else
                    yout_r <= yout_r;
                // shift areg left by 1 and breg right by 1
                areg <= {areg[14:0], 1'b0};
                breg <= {1'b0, breg[15:1]};
            end
        end else begin
            // when not start, hold registers
            areg   <= areg;
            breg   <= breg;
            yout_r <= yout_r;
        end
    end

    // output assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            yout <= 32'd0;
        else
            yout <= yout_r;
    end

endmodule