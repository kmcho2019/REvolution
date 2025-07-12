module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// State encoding
localparam S0 = 2'b00;  // Strongly not-taken
localparam S1 = 2'b01;  // Weakly not-taken (reset state)
localparam S2 = 2'b10;  // Weakly taken
localparam S3 = 2'b11;  // Strongly taken

reg [1:0] next_state;

// Combinational next state logic
always_comb begin
    if (areset) begin
        next_state = S1;
    end
    else if (train_valid) begin
        case (state)
            S0: next_state = train_taken ? S1 : S0;
            S1: next_state = train_taken ? S2 : S0;
            S2: next_state = train_taken ? S3 : S1;
            S3: next_state = train_taken ? S3 : S2;
        endcase
    end
    else begin
        next_state = state;  // Hold when not training
    end
end

// Sequential state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= S1;
    end else begin
        state <= next_state;
    end
end

endmodule