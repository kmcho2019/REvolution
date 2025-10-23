module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:1] count_h;  // bits 9 down to 1 as registers
    wire dff_q0, dff_d0; // D flip-flop output and input (bit 0)
    
    reg tc_reg;
    assign tc = tc_reg;

    // We implement bit0 with a D flip-flop
    // On clock edge: dff_q0 <= dff_d0

    // Current bit0 state:
    reg dff_q0_reg;
    assign dff_q0 = dff_q0_reg;

    // The full count is {count_h, dff_q0}
    wire [9:0] count = {count_h, dff_q0};

    // Next value logic for count when load=0 and count!=0 (decrement by 1)
    wire count_zero = (count == 0);

    // To decrement count by 1
    wire [9:0] count_dec = count - 1;

    // Next state logic:
    wire [9:0] count_next;
    assign count_next = load ? data : (count_zero ? count : count_dec);

    // Next bit0 value (to feed the D flip-flop)
    assign dff_d0 = count_next[0];

    // Sequential logic on posedge clk
    always @(posedge clk) begin
        if (load) begin
            count_h <= data[9:1];
            dff_q0_reg <= data[0];
            tc_reg <= (data == 0);
        end else begin
            if (!count_zero) begin
                count_h <= count_next[9:1];
                dff_q0_reg <= dff_d0;
                tc_reg <= (count_next == 0);
            end else begin
                // count zero: stay zero, tc asserted
                count_h <= count_h;
                dff_q0_reg <= dff_q0_reg;
                tc_reg <= 1'b1;
            end
        end
    end

endmodule