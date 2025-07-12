module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [6:0] state_index;  // 7-bit counter for 128 states (64-bit Johnson counter)
wire direction;         // 0 = increment, 1 = decrement

// Direction control: 0 when in increment phase (patterns 0-63), 1 when in decrement phase (patterns 64-127)
assign direction = (state_index[6]) ? 1'b1 : 1'b0;

// Pattern generator function
function [63:0] gen_pattern;
    input [6:0] idx;
    begin
        if (idx[6] == 0) begin
            // Increment phase (0-63)
            gen_pattern = {64{1'b0}};
            for (integer i = 0; i < 64; i = i + 1) begin
                if (i <= idx[5:0]) gen_pattern[63-i] = 1'b1;
            end
        end
        else begin
            // Decrement phase (64-127)
            gen_pattern = {64{1'b1}};
            for (integer i = 0; i < 64; i = i + 1) begin
                if (i <= (127 - idx)) gen_pattern[i] = 1'b0;
            end
        end
    end
endfunction

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state_index <= 7'd0;
        Q <= 64'b0;
    end
    else begin
        // Update state index
        if (direction) begin
            // Decrement phase
            if (state_index == 7'd64) state_index <= 7'd127;  // Wrap-around
            else state_index <= state_index - 1;
        end
        else begin
            // Increment phase
            if (state_index == 7'd63) state_index <= 7'd64;  // Transition to decrement phase
            else state_index <= state_index + 1;
        end
        
        // Generate output pattern
        Q <= gen_pattern(state_index);
    end
end

endmodule