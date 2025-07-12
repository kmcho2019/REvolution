module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // State encoding
    localparam NORMAL      = 2'b00;
    localparam OVERHEATED  = 2'b01;
    localparam ARRIVED     = 2'b10;
    localparam EMPTY_TANK  = 2'b11;

    reg [1:0] current_state;

    always @(*) begin
        // State transition logic
        case (1'b1)
            cpu_overheated: current_state = OVERHEATED;
            arrived:        current_state = ARRIVED;
            gas_tank_empty: current_state = EMPTY_TANK;
            default:        current_state = NORMAL;
        endcase

        // Output logic based on state
        shut_off_computer = (current_state == OVERHEATED);
        keep_driving = (current_state == NORMAL) || 
                      ((current_state == EMPTY_TANK) && ~arrived);
    end

endmodule