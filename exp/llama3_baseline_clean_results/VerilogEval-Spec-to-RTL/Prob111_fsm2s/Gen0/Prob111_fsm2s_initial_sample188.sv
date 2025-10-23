module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

reg [1:0] state; // States: OFF (2'b00), ON (2'b01)
reg [1:0] nextState;

// Output logic
always @(*)
begin
    case(state)
        2'b00: out = 1'b0; // OFF state
        2'b01: out = 1'b1; // ON state
        default: out = 1'b0; // Default to OFF
    endcase
end

// State transition logic
always @(posedge clk)
begin
    if(reset)
    begin
        state <= 2'b00; // Reset to OFF state
    end
    else
    begin
        case(state)
            2'b00: // OFF state
            begin
                if(j)
                begin
                    state <= 2'b01; // Move to ON state if j=1
                end
                else
                begin
                    state <= 2'b00; // Stay in OFF state if j=0
                end
            end
            2'b01: // ON state
            begin
                if(k)
                begin
                    state <= 2'b00; // Move to OFF state if k=1
                end
                else
                begin
                    state <= 2'b01; // Stay in ON state if k=0
                end
            end
            default: state <= 2'b00; // Default to OFF state
        endcase
    end
end

endmodule