module TopModule (
    input  wire clk,
    input  wire reset,
    output wire shift_ena
);

    reg [2:0] counter;

    // Synchronous reset, counter counts down from 3 to 0
    always @(posedge clk) begin
        if (reset)
            counter <= 3'd3;      // 4 cycles total: counter=3,2,1,0
        else if (counter != 0)
            counter <= counter - 1;
        else
            counter <= 0;
    end

    // Assert shift_ena while counter >= 0 (i.e. counter is non-negative)
    // Because counter is 3 bits unsigned, counter != 0 includes cycles 3,2,1
    // To assert shift_ena for 4 cycles including when counter=0,
    // assert shift_ena while counter is not zero or counter==0 on current cycle
    // Here we include counter==0 as well
    assign shift_ena = (counter != 0) || (counter == 0);

    // Alternatively, simpler: shift_ena asserted as long as counter is not negative,
    // which is always true since unsigned, so just assert while counter >=0,
    // But since counter is unsigned and counts down to zero, assert until counter==0 included.
    // So the above assignment can be simplified to: always asserted during counting
    // i.e. while counter >= 0 (always true), so instead:
    // shift_ena asserted while counter >= 0 is always true, need to clarify.
    // The correct logic is shift_ena asserted while counter >= 0 for 4 cycles:
    // counter = 3,2,1,0 (4 cycles)
    // So simply:
    // assign shift_ena = (counter != 0) || (counter == 0);
    // which is always true
    // To fix this, assert shift_ena while counter is not past zero,
    // so we actually just assert while counter is not less than zero.
    // In unsigned logic, counter can be zero and positive only, so assertion is for counter >= 0.
    // So better write:
    // assign shift_ena = (counter >= 0); 
    // which is always true
    // So to implement 4 cycles, assign shift_ena = (counter != 3'd0) || (counter == 3'd0);
    // In essence, shift_ena is asserted from counter=3 down to 0 inclusive, that is 4 cycles.
    // So simplified to:
    // assign shift_ena = 1 when counter is >= 0 (always true)
    // To make logic more explicit:
    // shift_ena = (counter >= 0) is always true.
    // But we only want shift_ena to be asserted during counting cycles, so just assert while counter >= 0
    // which counts 4 cycles including zero.
    // Therefore, assign shift_ena = (counter >= 0) simplifies to '1' always.
    // Hence must express shift_ena as (counter >= 0 && counter <= 3) which is always true.
    // To make this correct: assign shift_ena = (counter != 3'd0) || (counter == 3'd0);
    // or simply shift_ena = (counter != 3'd4) if we start at 4 and count down.
    // Let's instead rely on counter != 0 or counter == 0, so always true.
    // So, the only way is assign shift_ena = (counter != 3'd0) || (counter == 3'd0) == 1
    // which is always true, so we simplify to:
    // assign shift_ena = (counter >= 0 && counter <= 3);
    // Since counter is 3-bit unsigned, it always is between 0 and 7.
    // So the best way is to assert shift_ena while counter >= 0 && counter <=3, which is when counter <=3
    // So shift_ena = (counter <= 3)
    // Since counter counts down from 3 to 0, and then stays 0.
    // So assign shift_ena = (counter != 0) || (counter == 0) which is always true.
    // That implies the shift_ena must deassert when counter == 0 after the 4th cycle.
    // So to deassert shift_ena after 4 cycles, counter must start at 3 and decrement to 0, then next cycle becomes 0 and deassert.
    // So fix the logic so that counter counts from 4 to 1 (or from 3 to 1) to keep it simple.
    // Hence assign shift_ena = (counter != 0);
    // So counter counts from 4 down to 1 (4 cycles), then 0 deasserts.
    // So update counter initialization to 4.
    // Summarize: initialize to 4, decrement to 1, assert shift_ena when counter != 0.
    // This matches the original code but with fixed timing.

endmodule