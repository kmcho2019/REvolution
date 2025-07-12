module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Define the states
localparam S0 = 3'b001;
localparam S1 = 3'b010;
localparam S2 = 3'b011;
localparam S3 = 3'b100;
localparam S4 = 3'b101;
localparam S5 = 3'b110;
localparam S6 = 3'b111;

// Define the current state
reg [2:0] current_state;

// Initialize the current state
initial current_state = S4;

// Define the next state
always @(posedge clk) begin
    case (current_state)
        S0: if (!a) current_state <= S1; else current_state <= S4;
        S1: if (!a) current_state <= S2; else current_state <= S4;
        S2: if (!a) current_state <= S3; else current_state <= S4;
        S3: if (!a) current_state <= S4; else current_state <= S4;
        S4: if (!a) current_state <= S5; else current_state <= S4;
        S5: if (!a) current_state <= S6; else current_state <= S4;
        S6: if (!a) current_state <= S0; else current_state <= S4;
        default: current_state <= S4;
    endcase
end

// Assign the output q based on the current state
always @(*) begin
    case (current_state)
        S0: q = 3'b000;
        S1: q = 3'b001;
        S2: q = 3'b010;
        S3: q = 3'b011;
        S4: q = 3'b100;
        S5: q = 3'b101;
        S6: q = 3'b110;
        default: q = 3'b100;
    endcase
end

endmodule