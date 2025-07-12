module multi_pipe_4bit #(
    parameter size = 4
)(
    input                  clk,
    input                  rst_n,
    input      [size-1:0]  mul_a,
    input      [size-1:0]  mul_b,
    output reg [2*size-1:0] mul_out
);

    localparam width = 2*size;

    // Extend multiplicand by zero-extending MSBs to width bits
    wire [width-1:0] a_ext = { {size{1'b0}}, mul_a };

    // State registers and control
    reg [width-1:0] accumulator;   // Holds running sum of partial products
    reg [$clog2(size):0] bit_index; // Counts which bit of multiplier is being processed (0 to size)

    // Register multiplier copy to hold during operation to avoid input changes mid-operation
    reg [size-1:0] multiplier_reg;

    // Busy flag: indicates multiplication in progress (1) or idle (0)
    reg busy;

    // Start multiplication on each cycle when not busy
    // To meet problem description, assume continuous multiplication of inputs; 
    // so start when not busy by loading inputs and resetting accumulator.

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator  <= {width{1'b0}};
            bit_index    <= 0;
            multiplier_reg <= {size{1'b0}};
            mul_out      <= {width{1'b0}};
            busy         <= 1'b0;
        end else begin
            if (!busy) begin
                // Load new inputs and start multiplying
                accumulator   <= {width{1'b0}};
                multiplier_reg <= mul_b;
                bit_index     <= 0;
                busy          <= 1'b1;
            end else begin
                // If busy, accumulate partial product corresponding to bit_index
                if (bit_index < size) begin
                    if (multiplier_reg[bit_index]) begin
                        // Add shifted multiplicand to accumulator
                        accumulator <= accumulator + (a_ext << bit_index);
                    end
                    bit_index <= bit_index + 1;
                end else begin
                    // Multiplication done, output result and clear busy to start new multiplication next cycle
                    mul_out <= accumulator;
                    busy    <= 1'b0;
                end
            end
        end
    end

endmodule