module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    // State definitions with counter
    localparam IDLE = 2'b00;
    localparam COUNTING = 2'b01;
    
    reg [1:0] state;
    reg [1:0] byte_count;

    // State transition logic
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
                        state <= IDLE;
                        byte_count <= 2'b0;
                    end else begin
                        byte_count <= byte_count + 1;
                    end
                end
            endcase
        end
    end

    // Output logic (combinational)
    assign done = (state == COUNTING) && (byte_count == 2'b10);

endmodule