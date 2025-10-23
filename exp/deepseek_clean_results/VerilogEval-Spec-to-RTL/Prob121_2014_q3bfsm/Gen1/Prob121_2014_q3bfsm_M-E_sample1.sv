module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // State encoding
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;

    // LUT for next state and output
    // Format: {next_state_x0, next_state_x1, z_value}
    reg [8:0] fsm_lut [0:4];
    initial begin
        fsm_lut[S0] = {S0, S1, 1'b0};
        fsm_lut[S1] = {S1, S4, 1'b0};
        fsm_lut[S2] = {S2, S1, 1'b0};
        fsm_lut[S3] = {S1, S2, 1'b1};
        fsm_lut[S4] = {S3, S4, 1'b1};
    end

    reg [2:0] current_state;
    wire [2:0] next_state;
    wire next_z;

    // LUT access
    assign {next_state, next_z} = x ? {fsm_lut[current_state][5:3], fsm_lut[current_state][0]} 
                                      : {fsm_lut[current_state][8:6], fsm_lut[current_state][0]};

    // State update
    always @(posedge clk) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Output update
    always @(posedge clk) begin
        if (reset)
            z <= 1'b0;
        else
            z <= next_z;
    end

endmodule