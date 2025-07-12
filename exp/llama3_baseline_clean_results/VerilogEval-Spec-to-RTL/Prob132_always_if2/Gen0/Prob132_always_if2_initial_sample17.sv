module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        if (cpu_overheated) begin
            shut_off_computer = 1; // Turn off the computer if it's overheated
        end else begin
            shut_off_computer = 0; // Otherwise, it's safe to keep the computer on
        end
    end

    always @(*) begin
        if (~arrived) begin
            keep_driving = ~gas_tank_empty; // Keep driving if not arrived and gas is available
        end else begin
            keep_driving = 0; // Stop driving once arrived, regardless of gas
        end
    end

endmodule