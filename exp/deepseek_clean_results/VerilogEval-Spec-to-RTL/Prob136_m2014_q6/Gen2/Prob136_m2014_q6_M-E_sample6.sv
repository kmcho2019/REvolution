module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    reg [2:0] state_counter;  // 0=A, 1=B, 2=C, 3=D, 4=E, 5=F

    // Next state calculation using arithmetic
    always @(posedge clk) begin
        if (reset) begin
            state_counter <= 3'd0;  // State A
        end else begin
            case (state_counter)
                3'd0: state_counter <= w ? 3'd0 : 3'd1;  // A -> A or B
                3'd1: state_counter <= w ? 3'd3 : 3'd2;  // B -> D or C
                3'd2: state_counter <= w ? 3'd3 : 3'd4;  // C -> D or E
                3'd3: state_counter <= w ? 3'd0 : 3'd5;  // D -> A or F
                3'd4: state_counter <= w ? 3'd3 : 3'd4;  // E -> D or E
                3'd5: state_counter <= w ? 3'd3 : 3'd2;  // F -> D or C
                default: state_counter <= 3'd0;
            endcase
        end
    end

    // Output is 1 when in states E (4) or F (5)
    always @(*) begin
        z = (state_counter >= 3'd4);
    end

endmodule