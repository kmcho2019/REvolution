module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// State definitions
localparam [1:0] S0 = 2'b00;
localparam [1:0] S1 = 2'b01;
localparam [1:0] S2 = 2'b10;
localparam [1:0] S3 = 2'b11;

// Next state logic
always @(*) begin
    if (train_valid) begin
        case (state)
            S0: state = train_taken ? S1 : S0;
            S1: state = train_taken ? S2 : S0;
            S2: state = train_taken ? S3 : S1;
            S3: state = train_taken ? S3 : S2;
            default: state = S1;
        endcase
    end else begin
        state = state; // maintain current state
    end
end

// State register with async reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= S1; // weakly not-taken
    else
        state <= state;
end

endmodule