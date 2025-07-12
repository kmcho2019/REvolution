module TopModule (
    input        clk,
    input        reset,
    input        x,
    output       z
);

// Define the number of states
parameter NUM_STATES = 3;

// Define the states
reg [NUM_STATES-1:0] current_state;
reg [NUM_STATES-1:0] next_state;

// Define the states
localparam S000 = 3'b000;
localparam S001 = 3'b001;
localparam S010 = 3'b010;
localparam S011 = 3'b011;
localparam S100 = 3'b100;
localparam S101 = 3'b101;
localparam S110 = 3'b110;
localparam S111 = 3'b111;

// Output logic
always @(*) begin
    case (current_state)
        S000: z = 1'b0;
        S001: z = 1'b0;
        S010: z = 1'b0;
        S011: z = 1'b1;
        S100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// Next state logic
always @(*) begin
    case (current_state)
        S000: next_state = (x == 1'b0)? S000 : S001;
        S001: next_state = (x == 1'b0)? S001 : S100;
        S010: next_state = (x == 1'b0)? S010 : S001;
        S011: next_state = (x == 1'b0)? S001 : S010;
        S100: next_state = (x == 1'b0)? S011 : S100;
        default: next_state = S000;
    endcase
end

// State update logic
always @(posedge clk) begin
    if (reset == 1'b1) begin
        current_state <= S000;
    end else begin
        current_state <= next_state;
    end
end

endmodule