module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [2:0] state;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
        end else begin
            case (state)
                3'b000: state <= data ? 3'b001 : 3'b000;
                3'b001: state <= data ? 3'b011 : 3'b000;
                3'b011: state <= data ? 3'b011 : 3'b110;
                3'b110: state <= data ? 3'b111 : 3'b000;
                default: state <= state; // Stay in terminal state
            endcase
        end
    end

    assign start_shifting = (state == 3'b111);

endmodule