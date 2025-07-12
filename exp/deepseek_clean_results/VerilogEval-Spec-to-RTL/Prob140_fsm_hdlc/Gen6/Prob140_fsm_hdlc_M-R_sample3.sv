module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // State encoding
    localparam S_0 = 3'd0;
    localparam S_1 = 3'd1;
    localparam S_2 = 3'd2;
    localparam S_3 = 3'd3;
    localparam S_4 = 3'd4;
    localparam S_5 = 3'd5;
    localparam S_6 = 3'd6;

    reg [2:0] state;
    reg disc_reg, flag_reg, err_reg;

    // Next state logic (combinational)
    wire [2:0] next_state = 
        (state == S_0) ? (in ? S_1 : S_0) :
        (state == S_1) ? (in ? S_2 : S_0) :
        (state == S_2) ? (in ? S_3 : S_0) :
        (state == S_3) ? (in ? S_4 : S_0) :
        (state == S_4) ? (in ? S_5 : S_0) :
        (state == S_5) ? (in ? S_6 : S_0) :
        (state == S_6) ? (in ? S_6 : S_0) : S_0;

    // Output logic (combinational)
    wire disc_next = (state == S_5) && !in;
    wire flag_next = (state == S_6) && !in;
    wire err_next  = (state == S_6) && in;

    // State and output registration
    always @(posedge clk) begin
        if (reset) begin
            state <= S_0;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
        end else begin
            state <= next_state;
            disc_reg <= disc_next;
            flag_reg <= flag_next;
            err_reg <= err_next;
        end
    end

    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule