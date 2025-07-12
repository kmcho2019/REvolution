module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b011;
parameter D = 3'b010;
parameter E = 3'b110;
parameter F = 3'b111;

// State register
reg [2:0] currentState;

// ROM to store next states and outputs
reg [2:0] nextState;
reg output_z;

// ROM contents
always @(*) begin
    case ({currentState, w})
        {A, 1'b0}: {nextState, output_z} = {B, 1'b0};
        {A, 1'b1}: {nextState, output_z} = {A, 1'b0};
        {B, 1'b0}: {nextState, output_z} = {C, 1'b0};
        {B, 1'b1}: {nextState, output_z} = {D, 1'b0};
        {C, 1'b0}: {nextState, output_z} = {E, 1'b0};
        {C, 1'b1}: {nextState, output_z} = {D, 1'b0};
        {D, 1'b0}: {nextState, output_z} = {F, 1'b0};
        {D, 1'b1}: {nextState, output_z} = {A, 1'b0};
        {E, 1'b0}: {nextState, output_z} = {E, 1'b1};
        {E, 1'b1}: {nextState, output_z} = {D, 1'b0};
        {F, 1'b0}: {nextState, output_z} = {C, 1'b1};
        {F, 1'b1}: {nextState, output_z} = {D, 1'b0};
        default: {nextState, output_z} = {A, 1'b0};
    endcase
end

// Update the state and output on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
        z <= 1'b0;
    end else begin
        currentState <= nextState;
        z <= output_z;
    end
end

endmodule