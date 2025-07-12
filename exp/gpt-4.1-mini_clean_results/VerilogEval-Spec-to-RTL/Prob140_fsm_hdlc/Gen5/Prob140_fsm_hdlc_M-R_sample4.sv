module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // Count consecutive ones (0 to 7+)
    reg [3:0] count_ones, next_count_ones;

    // Registered outputs for one-cycle pulses
    reg disc_r, flag_r, err_r;
    wire disc_d, flag_d, err_d;

    // Error state latch
    reg err_state, next_err_state;

    // Combinational detection of outputs and next count
    always @(*) begin
        // Default assignments
        disc_d = 1'b0;
        flag_d = 1'b0;
        err_d  = 1'b0;
        next_count_ones = count_ones;
        next_err_state = err_state;

        if (err_state) begin
            // Stay in error state until zero input
            if (in == 1'b0) begin
                // Clear error on zero input
                next_err_state = 1'b0;
                next_count_ones = 4'd0;
            end
            // Outputs while in error state
            err_d = 1'b1;
            // disc and flag are zero here
        end else begin
            if (in) begin
                // Input is 1: increment count, cap at 7 for error detection
                if (count_ones < 7)
                    next_count_ones = count_ones + 1;
                else
                    next_count_ones = 7;

                // Check for error condition if count reaches 7
                if (count_ones + 1 >= 7) begin
                    next_err_state = 1'b1;
                    err_d = 1'b1;
                end
            end else begin
                // Input zero: outputs depend on count before reset
                case(count_ones)
                    5: disc_d = 1'b1; // discard bit after 5 consecutive ones then zero
                    6: flag_d = 1'b1; // flag after 6 consecutive ones then zero
                    default: begin
                        // no output for other counts
                    end
                endcase
                next_count_ones = 4'd0;
            end
        end
    end

    // Sequential logic: register count, error state, and outputs
    always @(posedge clk) begin
        if (reset) begin
            count_ones <= 4'd0;
            err_state  <= 1'b0;
            disc_r     <= 1'b0;
            flag_r     <= 1'b0;
            err_r      <= 1'b0;
        end else begin
            count_ones <= next_count_ones;
            err_state  <= next_err_state;
            // Outputs asserted for one clock cycle after condition detected
            disc_r     <= disc_d;
            flag_r     <= flag_d;
            err_r      <= err_d;
        end
    end

    // Assign registered outputs
    always @(*) begin
        disc = disc_r;
        flag = flag_r;
        err  = err_r;
    end

endmodule