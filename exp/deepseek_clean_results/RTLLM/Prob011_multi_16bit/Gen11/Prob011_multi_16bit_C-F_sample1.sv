module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [4:0] count;        // Counts 0-16 (5 bits)
    reg [15:0] areg;        // Multiplicand register
    reg [31:0] acc;         // Accumulator
    wire accumulate;        // Accumulation enable

    // Accumulation control
    assign accumulate = (count > 0) && (count < 17) && areg[count-1];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            count <= 5'd0;
            areg <= 16'd0;
            acc <= 32'd0;
            done <= 1'b0;
        end else begin
            if (start) begin
                if (count == 0) begin
                    // Initialization phase
                    areg <= ain;
                    acc <= 32'd0;
                    count <= count + 1;
                    done <= 1'b0;
                end else if (count < 16) begin
                    // Calculation phase
                    if (accumulate) begin
                        acc <= acc + (bin << (count-1));
                    end
                    count <= count + 1;
                end else if (count == 16) begin
                    // Final accumulation
                    if (accumulate) begin
                        acc <= acc + (bin << 15);
                    end
                    count <= count + 1;
                    done <= 1'b1;
                end else begin
                    // Completion (count == 17)
                    count <= 5'd0;
                    done <= 1'b0;
                end
            end else begin
                // Idle state
                count <= 5'd0;
                done <= 1'b0;
            end
        end
    end

    // Output assignment
    always @(*) begin
        yout = acc;
    end

endmodule