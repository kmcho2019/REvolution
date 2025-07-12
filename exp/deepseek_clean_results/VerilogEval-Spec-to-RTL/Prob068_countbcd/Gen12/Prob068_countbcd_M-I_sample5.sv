module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output [15:0] q
);

    parameter DIGITS = 4;
    parameter DIGIT_WIDTH = 4;
    
    reg [DIGITS*DIGIT_WIDTH-1:0] counter;
    assign q = counter;
    
    // Next digit values
    wire [DIGITS*DIGIT_WIDTH-1:0] next_counter;
    wire [DIGITS-1:0] digit_rollover;
    
    // Generate rollover and increment logic for each digit
    genvar i;
    generate
        for (i = 0; i < DIGITS; i = i + 1) begin : digit_gen
            // Rollover condition for this digit
            assign digit_rollover[i] = (counter[i*DIGIT_WIDTH +: DIGIT_WIDTH] == {DIGIT_WIDTH{1'b1}});
            
            // Next value calculation
            if (i == 0) begin
                // Always increment ones digit
                assign next_counter[i*DIGIT_WIDTH +: DIGIT_WIDTH] = 
                    digit_rollover[i] ? {DIGIT_WIDTH{1'b0}} : 
                    counter[i*DIGIT_WIDTH +: DIGIT_WIDTH] + 1'b1;
            end else begin
                // Higher digits only increment when lower digits roll over
                assign next_counter[i*DIGIT_WIDTH +: DIGIT_WIDTH] = 
                    (&digit_rollover[i-1:0]) ? 
                        (digit_rollover[i] ? {DIGIT_WIDTH{1'b0}} : 
                         counter[i*DIGIT_WIDTH +: DIGIT_WIDTH] + 1'b1) :
                    counter[i*DIGIT_WIDTH +: DIGIT_WIDTH];
            end
        end
    endgenerate
    
    // Registered enable signals
    always @(posedge clk) begin
        if (reset) begin
            ena <= 3'b0;
        end else begin
            ena[0] <= digit_rollover[0];
            ena[1] <= &digit_rollover[1:0];
            ena[2] <= &digit_rollover[2:0];
        end
    end
    
    // Counter update
    always @(posedge clk) begin
        if (reset) begin
            counter <= {DIGITS*DIGIT_WIDTH{1'b0}};
        end else begin
            counter <= next_counter;
        end
    end

endmodule