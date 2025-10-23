module calendar(
    input CLK, 
    input RST, 
    output reg [5:0] Secs, 
    output reg [5:0] Mins, 
    output reg [4:0] Hours
);

reg [1:0] state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 2'b00; // IDLE state
        Secs <= 6'b0;
        Mins <= 6'b0;
        Hours <= 5'b0;
    end else begin
        case (state)
            2'b00: // IDLE state
                begin
                    Secs <= Secs + 1'b1;
                    if (Secs == 6'd59) begin
                        state <= 2'b01; // UPDATE_MINUTES state
                        Secs <= 6'b0;
                    end
                end
            2'b01: // UPDATE_MINUTES state
                begin
                    Mins <= Mins + 1'b1;
                    if (Mins == 6'd59) begin
                        state <= 2'b10; // UPDATE_HOURS state
                        Mins <= 6'b0;
                    end else begin
                        state <= 2'b00; // IDLE state
                    end
                end
            2'b10: // UPDATE_HOURS state
                begin
                    Hours <= Hours + 1'b1;
                    if (Hours == 5'd23) begin
                        Hours <= 5'b0;
                    end
                    state <= 2'b00; // IDLE state
                end
            default: state <= 2'b00; // IDLE state
        endcase
    end
end

endmodule