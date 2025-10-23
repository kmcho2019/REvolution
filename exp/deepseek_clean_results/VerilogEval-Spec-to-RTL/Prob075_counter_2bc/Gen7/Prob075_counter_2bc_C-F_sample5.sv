module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    // State encoding with meaningful names
    localparam S0 = 2'b00;  // Strongly not-taken
    localparam S1 = 2'b01;  // Weakly not-taken (reset state)
    localparam S2 = 2'b10;  // Weakly taken
    localparam S3 = 2'b11;  // Strongly taken

    reg [1:0] current_state, next_state;

    // Combinational next state logic
    always @(*) begin
        if (train_valid) begin
            case (current_state)
                S0: next_state = train_taken ? S1 : S0;
                S1: next_state = train_taken ? S2 : S0;
                S2: next_state = train_taken ? S3 : S1;
                S3: next_state = train_taken ? S3 : S2;
                default: next_state = S1;
            endcase
        end else begin
            next_state = current_state;  // Hold state when not training
        end
    end

    // Sequential state register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= S1;
        else
            current_state <= next_state;
    end

    assign state = current_state;

endmodule