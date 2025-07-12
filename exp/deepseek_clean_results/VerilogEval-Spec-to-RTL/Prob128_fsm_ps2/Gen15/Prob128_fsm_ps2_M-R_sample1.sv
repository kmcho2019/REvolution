module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    // State definitions
    localparam WAIT_FIRST = 2'b00;
    localparam SECOND_BYTE = 2'b01;
    localparam THIRD_BYTE = 2'b10;

    reg [1:0] state;

    // Combinational done output
    assign done = (state == THIRD_BYTE);

    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FIRST;
        end else begin
            case (state)
                WAIT_FIRST: 
                    if (in[3]) state <= SECOND_BYTE;
                
                SECOND_BYTE: 
                    state <= THIRD_BYTE;
                
                THIRD_BYTE: 
                    state <= WAIT_FIRST;
                
                default: 
                    state <= WAIT_FIRST;
            endcase
        end
    end

endmodule