module multi_16bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [15:0] ain,
    input  wire [15:0] bin,
    output reg  [31:0] yout,
    output reg         done
);

    reg [4:0]  i;          // shift count: 0..16
    reg [15:0] areg;       // multiplicand
    reg [15:0] breg;       // multiplier
    reg [31:0] yout_r;     // product accumulator
    reg        done_r;     // done flag internal

    // Control: shift count and done flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i      <= 5'd0;
            done_r <= 1'b0;
        end else begin
            if (start) begin
                if (i < 5'd17) 
                    i <= i + 1;
                if (i == 5'd16)
                    done_r <= 1'b1;
                else if (i == 5'd17)
                    done_r <= 1'b0;
            end else begin
                i      <= 5'd0;
                done_r <= 1'b0;
            end
        end
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                areg   <= ain;
                breg   <= bin;
                yout_r <= 32'd0;
            end else if (i > 5'd0 && i < 5'd17) begin
                if (areg[i-1])
                    yout_r <= yout_r + ( {16'd0, breg} << (i-1) );
            end
        end
    end

    // Output assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            yout <= 32'd0;
            done <= 1'b0;
        end else begin
            yout <= yout_r;
            done <= done_r;
        end
    end

endmodule