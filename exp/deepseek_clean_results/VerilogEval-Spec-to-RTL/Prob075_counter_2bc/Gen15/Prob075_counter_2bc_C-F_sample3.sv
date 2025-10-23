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

wire do_increment = train_valid & train_taken;
wire do_decrement = train_valid & ~train_taken;

reg [1:0] next_state;

// Combinational next state logic
always @(*) begin
    if (areset) begin
        next_state = S1;
    end
    else if (do_increment) begin
        case (state)
            S0: next_state = S1;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = S3;
            default: next_state = S1;
        endcase
    end
    else if (do_decrement) begin
        case (state)
            S0: next_state = S0;
            S1: next_state = S0;
            S2: next_state = S1;
            S3: next_state = S2;
            default: next_state = S1;
        endcase
    end
    else begin
        next_state = state;
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