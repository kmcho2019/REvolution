module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    reg [9:0] next_state_reg;
    reg out1_reg;
    reg out2_reg;

    always @(*) begin
        next_state_reg = 10'b0; // Initialize next_state to zero
        out1_reg = 1'b0; // Initialize out1 to zero
        out2_reg = 1'b0; // Initialize out2 to zero

        case ({state, in})
            10'b0000000000_0: {next_state_reg, out1_reg, out2_reg} = {10'b1, 1'b0, 1'b0};
            10'b0000000000_1: {next_state_reg, out1_reg, out2_reg} = {10'b0000000001, 1'b0, 1'b0};
            10'b0000000001_0: {next_state_reg, out1_reg, out2_reg} = {10'b1, 1'b0, 1'b0};
            10'b0000000001_1: {next_state_reg, out1_reg, out2_reg} = {10'b0000000010, 1'b0, 1'b0};
            10'b0000000010_0: {next_state_reg, out1_reg, out2_reg} = {10'b1, 1'b0, 1'b0};
            10'b0000000010_1: {next_state_reg, out1_reg, out2_reg} = {10'b0000000100, 1'b0, 1'b0};
            10'b0000000100_0: {next_state_reg, out1_reg, out2_reg} = {10'b1, 1'b0, 1'b0};
            10'b0000000100_1: {next_state_reg, out1_reg, out2_reg} = {10'b0000001000, 1'b0, 1'b0};
            10'b0000001000_0: {next_state_reg, out1_reg, out2_reg} = {10'b1, 1'b0, 1'b0};
            10'b0000001000_1: {next_state_reg, out1_reg, out2_reg} = {10'b0000010000, 1'b0, 1'b0};
            10'b0000010000_0: {next_state_reg, out1_reg, out2_reg} = {10'b1, 1'b0, 1'b0};
            10'b0000010000_1: {next_state_reg, out1_reg, out2_reg} = {10'b0000100000, 1'b0, 1'b0};
            10'b0000100000_0: {next_state_reg, out1_reg, out2_reg} = {10'b1000000000, 1'b0, 1'b0};
            10'b0000100000_1: {next_state_reg, out1_reg, out2_reg} = {10'b0001000000, 1'b0, 1'b0};
            10'b0001000000_0: {next_state_reg, out1_reg, out2_reg} = {10'b1000000000, 1'b0, 1'b0};
            10'b0001000000_1: {next_state_reg, out1_reg, out2_reg} = {10'b0010000000, 1'b0, 1'b0};
            10'b0010000000_0: {next_state_reg, out1_reg, out2_reg} = {10'b0100000000, 1'b0, 1'b0};
            10'b0010000000_1: {next_state_reg, out1_reg, out2_reg} = {10'b0000000000, 1'b0, 1'b1};
            10'b0100000000_0: {next_state_reg, out1_reg, out2_reg} = {10'b1, 1'b1, 1'b0};
            10'b0100000000_1: {next_state_reg, out1_reg, out2_reg} = {10'b1, 1'b1, 1'b0};
            default: {next_state_reg, out1_reg, out2_reg} = {10'b1, 1'b0, 1'b0};
        endcase
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule