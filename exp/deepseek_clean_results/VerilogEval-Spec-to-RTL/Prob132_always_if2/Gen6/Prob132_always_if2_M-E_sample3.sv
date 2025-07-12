module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Internal state representation
    typedef enum {SAFE, OVERHEATED, DRIVING} system_state;
    system_state state;

    always @(*) begin
        // Default outputs
        shut_off_computer = 0;
        keep_driving = 0;
        state = SAFE;

        // Priority-based control
        if (cpu_overheated) begin
            shut_off_computer = 1;
            state = OVERHEATED;
        end
        else if (~arrived) begin
            keep_driving = ~gas_tank_empty;
            state = gas_tank_empty ? SAFE : DRIVING;
        end
    end

endmodule