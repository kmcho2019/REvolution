module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // State definitions for computer control
    localparam COMP_NORMAL = 1'b0;
    localparam COMP_SHUTDOWN = 1'b1;

    // State definitions for driving control
    localparam DRIVE_STOPPED = 1'b0;
    localparam DRIVE_DRIVING = 1'b1;

    // Computer control state machine
    always @(*) begin
        case (shut_off_computer)
            COMP_NORMAL:
                shut_off_computer = cpu_overheated ? COMP_SHUTDOWN : COMP_NORMAL;
            COMP_SHUTDOWN:
                shut_off_computer = COMP_SHUTDOWN; // Once shutdown, stays shutdown
        endcase
    end

    // Driving control state machine
    always @(*) begin
        case (keep_driving)
            DRIVE_STOPPED:
                keep_driving = (~arrived & ~gas_tank_empty) ? DRIVE_DRIVING : DRIVE_STOPPED;
            DRIVE_DRIVING:
                keep_driving = (arrived | gas_tank_empty) ? DRIVE_STOPPED : DRIVE_DRIVING;
        endcase
    end

endmodule