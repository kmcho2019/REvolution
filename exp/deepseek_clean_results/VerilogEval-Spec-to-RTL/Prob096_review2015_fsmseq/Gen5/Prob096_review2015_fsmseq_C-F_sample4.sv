module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State encoding with descriptive names
    localparam IDLE  = 3'b000;
    localparam S1    = 3'b001;
    localparam S2    = 3'b010;
    localparam S3    = 3'b011;
    localparam FOUND = 3'b100;

    reg [2:0] state;

    // Combined state transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:  state <= data ? S1 : IDLE;
                S1:    state <= data ? S2 : IDLE;
                S2:    state <= data ? S2 : S3;
                S3:    state <= data ? FOUND : IDLE;
                FOUND: state <= FOUND;
                default: state <= IDLE;
            endcase
        end
    end

    // Simple output assignment
    assign start_shifting = (state == FOUND);

endmodule