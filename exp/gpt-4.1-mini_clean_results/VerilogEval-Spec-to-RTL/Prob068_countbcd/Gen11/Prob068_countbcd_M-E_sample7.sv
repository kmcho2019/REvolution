module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] count;

    // Function to increment a single BCD digit and return next digit and carry out
    function [4:0] bcd_increment;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_increment = {1'b1, 4'd0}; // carry out = 1, digit reset to 0
            else
                bcd_increment = {1'b0, digit + 1'b1}; // no carry, digit incremented
        end
    endfunction

    wire [4:0] ones_res, tens_res, hundreds_res, thousands_res;

    // Increment ones digit
    assign ones_res = bcd_increment(count[3:0]);

    // Increment tens digit with carry from ones
    assign tens_res = bcd_increment(count[7:4] + {3'b000, ones_res[4]}); 
    // Above: add carry from ones_res[4] to tens digit, then increment if needed

    // Increment hundreds digit with carry from tens
    assign hundreds_res = bcd_increment(count[11:8] + {3'b000, tens_res[4]});

    // Increment thousands digit with carry from hundreds
    assign thousands_res = bcd_increment(count[15:12] + {3'b000, hundreds_res[4]});

    // Enable signals indicate when each higher digit increments
    assign ena[0] = ones_res[4];      // carry from ones increments tens
    assign ena[1] = tens_res[4];      // carry from tens increments hundreds
    assign ena[2] = hundreds_res[4];  // carry from hundreds increments thousands

    always @(posedge clk) begin
        if (reset) begin
            count <= 16'd0;
        end else begin
            count[3:0]    <= ones_res[3:0];
            count[7:4]    <= tens_res[3:0];
            count[11:8]   <= hundreds_res[3:0];
            count[15:12]  <= thousands_res[3:0];
        end
    end

    assign q = count;

endmodule