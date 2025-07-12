module TopModule(clk, reset, s, w, z);
    input clk;
    input reset;
    input s;
    input w;
    output reg z = 1'b0;

    reg [1:0] state = 2'b00; // 2 states: A (00), B (01), C1 (10), C2 (11)
    reg [1:0] count = 2'b00; // counter for w = 1 occurrences
    reg [1:0] cycle = 2'b00; // counter for clock cycles

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00; // reset to state A
            count <= 2'b00;
            cycle <= 2'b00;
            z <= 1'b0;
        end else begin
            case (state)
                2'b00: begin // state A
                    if (s) begin
                        state <= 2'b01; // transition to state B
                        cycle <= 2'b01; // start counting clock cycles
                        count <= 2'b00; // reset counter
                    end else begin
                        state <= 2'b00; // stay in state A
                    end
                end
                2'b01: begin // state B
                    if (cycle < 3) begin // check for 3 clock cycles
                        cycle <= cycle + 1;
                        if (w) begin
                            count <= count + 1; // increment counter if w = 1
                        end
                        state <= 2'b01; // stay in state B
                    end else begin // 3 clock cycles passed
                        if (count == 2) begin // check if w = 1 exactly twice
                            z <= 1'b1;
                        end else begin
                            z <= 1'b0;
                        end
                        state <= 2'b01; // stay in state B
                        cycle <= 2'b01; // reset clock cycle counter
                        count <= 2'b00; // reset counter
                    end
                end
                default: state <= 2'b00; // default to state A
            endcase
        end
    end
endmodule