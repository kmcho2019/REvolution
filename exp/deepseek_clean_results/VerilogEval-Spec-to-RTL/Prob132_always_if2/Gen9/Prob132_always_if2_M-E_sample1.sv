module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // State encoding parameters
    localparam SAFE = 2'b00, OVERHEAT = 2'b01, DRIVING = 2'b10;
    reg [1:0] current_state;

    always @(*) begin
        // Default assignments
        shut_off_computer = 1'b0;
        keep_driving = 1'b0;
        current_state = SAFE;

        // Priority-encoded state transitions
        if (cpu_overheated) begin
            current_state = OVERHEAT;
            shut_off_computer = 1'b1;
        end
        else if (~arrived) begin
            current_state = DRIVING;
            keep_driving = ~gas_tank_empty;
        end
    end

endmodule