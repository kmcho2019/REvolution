module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // Count of consecutive ones: 0 to 7 (7 means error condition)
    reg [2:0] ones_count;

    // Next count combinational logic
    wire [2:0] next_ones_count;

    // Compute next_ones_count based on current count and input
    // Increment count if input==1 and count <7 (saturate at 7)
    // Reset count to 0 on input==0
    assign next_ones_count = (in) ?
                                ((ones_count < 3'd7) ? ones_count + 3'd1 : 3'd7)
                              : 3'd0;

    always @(posedge clk) begin
        if (reset) begin
            ones_count <= 3'd0;
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            ones_count <= next_ones_count;

            // Default outputs low
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= (ones_count == 3'd7);

            // Output logic delayed by one cycle (Moore output)
            // Conditions for disc and flag outputs:
            // To detect disc: when previous count was 5 and current input is 0
            // To detect flag: when previous count was 6 and current input is 0

            // We can detect this by looking at ones_count before update and input
            // But ones_count is updated before output in this implementation,
            // so store previous count.

            // Because outputs asserted one cycle after detection, 
            // we register these outputs on this clock edge using previous states.

            // So we store previous ones_count and input in internal regs.

        end
    end

    // To implement correct one-cycle delay outputs, store previous ones_count and input
    reg [2:0] prev_ones_count;
    reg       prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_ones_count <= 3'd0;
            prev_in <= 1'b0;
        end else begin
            prev_ones_count <= ones_count;
            prev_in <= in;
        end
    end

    // Now generate disc and flag outputs synchronously based on previous count and previous input
    always @(posedge clk) begin
        if (reset) begin
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            // disc: previous count == 5, previous input == 0
            disc <= (prev_ones_count == 3'd5) && (prev_in == 1'b0);
            // flag: previous count == 6, previous input == 0
            flag <= (prev_ones_count == 3'd6) && (prev_in == 1'b0);
            // err: ones_count == 7 (continuous error until reset or input 0)
            err  <= (ones_count == 3'd7);
        end
    end

endmodule