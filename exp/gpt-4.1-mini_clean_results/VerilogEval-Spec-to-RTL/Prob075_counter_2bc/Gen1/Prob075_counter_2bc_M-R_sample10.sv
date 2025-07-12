module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg  [1:0] state
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset state
        end else if (train_valid) begin
            case (state)
                2'd0: state <= train_taken ? 2'd1 : 2'd0;
                2'd1: state <= train_taken ? 2'd2 : 2'd0;
                2'd2: state <= train_taken ? 2'd3 : 2'd1;
                2'd3: state <= train_taken ? 2'd3 : 2'd2;
                default: state <= 2'b01;
            endcase
        end
        // else keep state unchanged (do nothing)
    end

endmodule