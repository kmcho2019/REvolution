module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] data;
reg [2:0] state;
reg [3:0] counter;
reg error;

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE state
        counter <= 0;
        data <= 0;
        error <= 0;
        done <= 0;
    end
    else begin
        case (state)
            0: // IDLE state
                begin
                    if (!in) begin
                        state <= 1; // START_BIT state
                        counter <= 0;
                    end
                    else if (error) begin
                        if (in) begin
                            error <= 0;
                        end
                    end
                end
            1: // START_BIT state
                begin
                    state <= 2; // DATA_BITS state
                end
            2: // DATA_BITS state
                begin
                    data <= {data[6:0], in};
                    counter <= counter + 1;
                    if (counter == 8) begin
                        state <= 3; // STOP_BIT state
                    end
                end
            3: // STOP_BIT state
                begin
                    if (in) begin
                        state <= 0; // IDLE state
                        done <= 1;
                    end
                    else begin
                        state <= 4; // ERROR state
                    end
                end
            4: // ERROR state
                begin
                    if (in) begin
                        state <= 0; // IDLE state
                        error <= 0;
                    end
                end
        endcase
    end
end

always @ (posedge clk) begin
    if (state == 0 && !reset) begin
        done <= 0;
    end
end

endmodule