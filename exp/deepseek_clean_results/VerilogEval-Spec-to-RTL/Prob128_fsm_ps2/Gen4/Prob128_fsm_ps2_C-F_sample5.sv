module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    // State definitions
    localparam IDLE = 1'b0;
    localparam COUNTING = 1'b1;

    reg state;
    reg [1:0] byte_count;

    // Next state and counter logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 2'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        state <= COUNTING;
                        byte_count <= 2'b1;
                    end
                end
                COUNTING: begin
                    if (byte_count == 2'b10) begin
                        // Message complete
                        state <= in[3] ? COUNTING : IDLE;
                        byte_count <= in[3] ? 2'b1 : 2'b0;
                    end else begin
                        byte_count <= byte_count + 1;
                    end
                end
            endcase
        end
    end

    // Output logic
    assign done = (state == COUNTING) && (byte_count == 2'b10);

endmodule